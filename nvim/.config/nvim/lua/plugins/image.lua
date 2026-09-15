return {
  "3rd/image.nvim",
  build = false, -- magick_cli 处理器不需要 lua rock
  opts = {
    -- Windows Terminal 只支持 sixel，不支持 Kitty graphics（microsoft/terminal#8389 未实现），
    -- 所以 backend 只能是 sixel。
    -- 注意：herdr 只实现 Kitty graphics、不支持 sixel，所以在 herdr 的 pane 里看不到图，
    -- 必须在 herdr 之外的终端里跑 nvim。
    backend = "sixel",
    processor = "magick_cli", -- 调用系统 ImageMagick 编码 sixel / 读取尺寸
    integrations = {
      markdown = {
        enabled = true,
        -- 远程图（img.shields.io、cdn.simpleicons.org 等）是 SVG 或 Cloudflare 拦截页，
        -- ImageMagick 处理失败时 image.nvim 会每张图抛一次 Lua 错误刷屏。
        download_remote_images = false,
        -- Windows Terminal 的 sixel 实现一次画多张容易错位/残留，只渲染光标下那一张最稳。
        -- 想全部内联就改成 false，并去掉下一行。
        only_render_image_at_cursor = true,
        only_render_image_at_cursor_mode = "popup",
        filetypes = { "markdown", "vimwiki" },
      },
    },
    max_width_window_percentage = 90,
    max_height_window_percentage = 50,
    hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp", "*.avif" },
  },
}
