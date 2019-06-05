class User < ApplicationRecord
  belongs_to :profile
  # has_secure_password
  validates :login, presence: true, length: {maximum: 50}
  # validates :password, presence: true, length: {minimum: 3}
  before_save {self.login.downcase}


  def self.encripitar_senha(password)
    return Digest::SHA1.hexdigest(password)
  end

  def self.gerar_codigo_ativacao
    numeros = (0..3).map {rand(1..9)}

    codigo = ""
    numeros.each do |numero|
      codigo << numero.to_s
    end

    return codigo
  end
end
