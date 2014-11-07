module RedmineLightboxHelper

  def link_to_attachment_with_preview(attachment, options = {})
    #TODO: remove this shit after the best way will be found
    self.class.send(:include, RedmineLightboxHelper) unless self.methods.include?(:preview_available?)

    redmine_lightbox_asset_options = options.dup
    
    original_link = link_to_attachment_without_preview(attachment, options)

    return original_link unless preview_available?(attachment)

    preview_icon = redmine_lightbox_asset_url('images/preview.png', redmine_lightbox_asset_options)
    icon_style = 'width: 24px; height:16px; margin: 0px 4px'
    preview_button = image_tag(preview_icon, :style => icon_style, :width => 24, :height => 16)

    raw("#{original_link}#{preview_link_with(attachment, preview_button, redmine_lightbox_asset_options)}")
  end

  def thumbnail_with_preview_tag(attachment)
    preview_link_with(attachment,
                      image_tag(url_for(:controller => 'attachments', :action => 'thumbnail', :id => attachment)))
  end

  def redmine_lightbox_asset_url(asset_url, options={})
    plugin_asset = options[:plugin_asset].nil? ? true : options.delete(:plugin_asset)
    only_path = options[:only_path].nil? ? true : options[:only_path]
    
    if plugin_asset
      paths = [
          'plugin_assets',
          'redmine_lightbox',
          asset_url
      ]
      relative_url = File.join(*paths)
    else
      relative_url = asset_url
    end

    (only_path) ? "#{home_path}#{relative_url}" : "#{home_url}#{relative_url}"
  end

  def preview_available?(attachment)
    image = attachment.image?
    pdf_or_swf = attachment.filename =~ /.(pdf|swf)$/i
    attachment_preview = attachment.transformed_preview
    text = attachment.is_text?

    image || text || pdf_or_swf || attachment_preview
  end

  def preview_link_with(attachment, preview_button, options={})
    only_path = options[:only_path].nil? ? true : options[:only_path]
    
    if attachment.transformed_preview
      link_class = "attachment_preview"
      attachment_action = "preview_inline"
    else
      if attachment.filename =~ /.(pdf|swf)$/i
        link_class = $1
      else
        link_class = "image"
      end
      attachment_action = ($1 === 'swf' || attachment.image?) ? 'download_inline' : ($1 === 'pdf') ? 'preview_inline' :'show'
    end

    if attachment.description.present?
      attachment_title = "#{attachment.filename}#{ ('-' + attachment.description)}"
    else
      attachment_title = attachment.filename
    end

    unless attachment.is_text?
      if attachment.transformed_preview || attachment.filename =~ /.(pdf|swf)$/
        link_to(preview_button, {
          :controller => 'attachments',
          :action => attachment_action,
          :id => attachment,
          :filename => attachment.filename,
          :only_path => only_path },
              :class => link_class,
              :title => attachment_title,
              :data  => {:fancybox_type => 'iframe'}
        )
      else
        link_to(preview_button, {
            :controller => 'attachments',
            :action => attachment_action,
            :id => attachment,
            :filename => attachment.filename,
            :only_path => only_path },
                :class => link_class,
                :rel => 'attachments',
                :title => attachment_title
        )
      end
    end
  end

end
