cask 'vencordinstaller' do
  version :latest
  sha256 :no_check

  url 'https://github.com/Vencord/Installer/releases/latest/download/VencordInstaller.MacOs.zip'
  name 'VencordInstaller'
  homepage 'https://github.com/Vencord/Installer'

  app 'VencordInstaller.app'
end
