defmodule Chatter.Iconify do
  @base_path "/images/workspace_icons/"
  @server_path [
    "priv",
    "static",
    "images",
    "workspace_icons"
  ]
  @colors [
    :red,
    :green,
    :blue,
    :yellow,
    :orange,
    :purple,
    :pink,
    :brown,
    :gray,
    :black,
    :white
  ]

  def make_icon(name) do
    color = Enum.random(@colors)

    icon_text =
      name
      |> String.upcase()
      |> String.slice(0..1)

    icon =
      Image.Text.text!(icon_text,
        background_fill_color: color,
        font_size: 200,
        padding: 80
      )
      |> Image.avatar!(shape: :square)

    dest = Path.join(@server_path)

    icon_name = name |> String.replace(" ", "_") |> String.downcase() |> Kernel.<>("_icon.jpg")

    filename = dest <> "/" <> icon_name
    icon_path = @base_path <> icon_name

    File.mkdir_p!(dest)
    Image.write(icon, filename)

    icon_path
  end
end
