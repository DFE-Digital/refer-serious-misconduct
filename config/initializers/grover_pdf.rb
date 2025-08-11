Grover.configure do |config|
  config.options = {
    format: "A4",
    margin: {
      top: "2cm",
      bottom: "2cm",
      left: "1cm",
      right: "1cm"
    },
    launch_args: ["--no-sandbox", "--disable-setuid-sandbox", "--disable-gpu"]
  }
end
