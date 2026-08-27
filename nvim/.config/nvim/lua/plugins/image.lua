return {
  "3rd/image.nvim",
  build = false, -- 避免 lazy 自动构建 lua rock
  opts = {
    backend = "sixel", -- Windows Terminal / WezTerm 都支持 Sixel
    processor = "magick_cli", -- 调用系统 ImageMagick 的 convert/identify
    integrations = {
      markdown = {
        enabled = true,
        download_remote_images = true,
        only_render_image_at_cursor = false,
        filetypes = { "markdown", "vimwiki" },
      },
    },
    max_height_window_percentage = 50,
    hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp", "*.avif" },
  },
}
