class MailAttachedHandler < ActiveRecord::Base
  require 'net/imap'
  require 'tmail'

  def self.download_imap
    self.download_imap_with_tmail
    #self.download_imap_with_mail
  end

  def self.download_imap_with_tmail
    config = YAML.load(File.read(File.join(Rails.root, 'config', 'mail.yml')))

    # GmailにIMAPで接続、ログインする
    p "try login to gmail"
    imap = Net::IMAP.new(config['host'],config['port'],true,nil,false)
    imap.login(config['username'],config['password']) # ID、パスワード
    p "login ok!"

    # 受信箱を開く
    imap.select('INBOX')
    exist_new_mail = false
    imap.uid_search(["UNSEEN"]).each do |uid| # 未読を対象
      exist_new_mail = true

      email = TMail::Mail.parse(imap.uid_fetch(uid,'RFC822').first.attr['RFC822'])
      p "got email from: " + email.from[0]

      Photo.save_image(email)
      imap.store(uid,"+FLAGS",[:Seen])    # 既読にする
      #imap.store(uid,'+FLAGS',[:Deleted]) # メールを削除する
      imap.expunge # :Deleted フラグを確定する
    end
    # 切断する
    imap.logout

    p "all email downloaded!"
    return exist_new_mail
  end

  def self.download_imap_with_mail
    p "download_imap_with_mail"

    config = YAML.load(File.read(File.join(Rails.root, 'config', 'mail.yml')))    

    Mail.defaults do
      retriever_method :imap, {:address => config['host'],
                           :port => config['port'],
                           :user_name => config['username'],
                           :password => config['password'],
                           :enable_ssl => true}
    end

    Mail.all(:delete_after_find => false).each do |email|
      begin
        if !email.attachments.blank?
          subject = email.subject   # => 件名（日本語可OK） UTF-8 で取得できる
          body = email.parts[0].body.to_s.encode("UTF-8", "ISO-2022-JP")    # => 本文は UTF-8 に変換する必要がある
          from = email[:from]       # => "\"濱田 章吾\" hamasyou@gmail.com"
          sent_at = email.date
          p from 

          email.attachments.each do |attachment|
#            tmp = File.new("tmp/photos/#{attachment.filename}", "wb")
#            tmp << attachment.read.force_encoding("UTF-8")
#            tmp.close
            p attachment.filename
          end
        end
      rescue => ignore
        p "[error]:" + ignore.to_s
      end
    end

  end

end
