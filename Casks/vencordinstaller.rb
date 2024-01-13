cask 'vencordinstaller' do
  version :latest 
  sha256 :no_check

  url 'https://github.com/Vencord/Installer/releases/latest/download/VencordInstaller.MacOs.zip'
  name 'VencordInstaller'
  desc "The cutest Discord client mod"
  homepage "https://vencord.dev/"

  app 'VencordInstaller.app'
end
