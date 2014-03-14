require 'net/smtp'


  
  
  
message = <<MESSAGE_END
From: Private Person <me@fromdomain.com>
To: Andy von Dohren <avondohren@gmail.com>
MIME-Version: 1.0
Content-type: text/html
Subject: SMTP e-mail test

This is an e-mail message to be sent in HTML format

<b>This is HTML message.</b>
<h1>This is headline.</h1>
MESSAGE_END

Net::SMTP.start('localhost') do |smtp|
  smtp.send_message message, 'contactus@myblog.com', 
                             'avondohren@gmail.com'
end


Net::SMTP.start('smtp.gmail.com', 
                25, 
                'gmail.com', 
                'avondohren', 'yaabaiizalojwnkw' :plain)
                
                
                
                yaabaiizalojwnkw