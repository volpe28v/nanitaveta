class MailAttachedHandler < ActiveRecord::Base
  require 'net/imap'
  require 'tmail'

  def self.download_imap
    config = YAML.load(File.read(File.join(Rails.root, 'config', 'mail.yml')))    

    # GmailにIMAPで接続、ログインする
    p "try login to gmail"
    imap = Net::IMAP.new(config['host'],config['port'],true,nil,false)
    imap.login(config['username'],config['password']) # ID、パスワード
    p "login ok!"

    # 受信箱を開く
    imap.select('INBOX')
    is_exist_new_mail = false
    imap.uid_search(["UNSEEN"]).each do |uid| # 未読を対象
      is_exist_new_mail = true

      email = TMail::Mail.parse(imap.uid_fetch(uid,'RFC822').first.attr['RFC822'])
      p "got email from: " + email.from[0]

      Photo.save_image(email)
      imap.store(uid,"+FLAGS",[:Seen])    #make read
      #imap.store(uid,'+FLAGS',[:Deleted]) #delete mail
      imap.expunge # :Deleted フラグを確定する
    end
    # 切断する
    imap.logout

    p "all email downloaded!"
    return is_exist_new_mail
  end
end
