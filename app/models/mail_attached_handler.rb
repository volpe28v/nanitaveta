class MailAttachedHandler < ActiveRecord::Base
  require 'net/imap'
  require 'tmail'

  def self.download_imap
    config = YAML.load(File.read(File.join(Rails.root, 'config', 'mail.yml')))    
    p config

    # GmailにIMAPで接続、ログインする
    imap = Net::IMAP.new(config['host'],config['port'],true,nil,false)
    imap.login(config['username'],config['password']) # ID、パスワード
    p "IMAP LOGIN"

    # 受信箱を開く
    imap.select('INBOX')
    p 'IMAP SELECT INDEX'
    imap.uid_search(["SEEN"]).each do |uid| # 未読を対象
      email = TMail::Mail.parse(imap.uid_fetch(uid,'RFC822').first.attr['RFC822'])
      p email.to
      p email.subject.toutf8

#      Photo.save_image(email)
#      imap.store(uid,"+FLAGS",[:Seen])    #make read
      #imap.store(uid,'+FLAGS',[:Deleted]) #delete mail  
#      imap.expunge # :Deleted フラグを確定する
    end
    # 切断する
    imap.logout
    p "IMAP LOGOUT"
  end
end
