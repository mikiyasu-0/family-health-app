module ApplicationHelper
  def default_meta_tags
    {
      site: "ファミリーステップ",
      reverse: true,
      charset: "utf-8",
      separator: "|"
    }
  end

  def top_page_meta_tags
    description = "家族でつながる、運動習慣サポートアプリ"
    image = image_url("ogp/family_step_ogp.png")
    image_alt = "ファミリーステップ 家族でつながる運動習慣サポートアプリ"

    {
      title: description,
      description: description,
      canonical: root_url,
      og: {
        site_name: "ファミリーステップ",
        title: "ファミリーステップ",
        description: description,
        type: "website",
        url: root_url,
        locale: "ja_JP",
        image: {
          _: image,
          type: "image/png",
          width: 1200,
          height: 630,
          alt: image_alt
        }
      },
      twitter: {
        card: "summary_large_image",
        title: "ファミリーステップ",
        description: description,
        image: {
          _: image,
          alt: image_alt
        }
      }
    }
  end
end
