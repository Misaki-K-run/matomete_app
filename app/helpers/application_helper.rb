module ApplicationHelper
  def flash_background_color(type)
    case type.to_sym
    when :notice then "bg-lime-300"
    when :alert  then "bg-red-300"
    when :error  then "bg-yellow-300"
    else "bg-gray-500"
    end
  end

  def default_meta_tags
    {
      site: "matomete",
      title: "一週間の献立をまとめて管理",
      reverse: true,
      charset: "utf-8",
      description: "一週間分の献立表と買い物リストをまとめて作成",
      keywords: "献立, 買い物リスト, OGP",
      canonical: request.original_url,
      separator: "|",
      icon: [
        { href: image_url("favicon-96x96.png"), sizes: "96x96", type: "image/png" },
        { href: image_url("apple-touch-icon.png"), rel: "apple-touch-icon", sizes: "180x180", type: "image/png" }
      ],
      og: {
        site_name: "matomete",
        title: "matomete",
        description: "一週間分の献立表と買い物リストをまとめて作成",
        type: "website",
        url: request.original_url,
        image: image_url("ogp.png"),
        locale: "ja-JP"
      },
      twitter: {
        card: "summary_large_image",
        image: image_url("ogp.png")
      }
    }
  end
end
