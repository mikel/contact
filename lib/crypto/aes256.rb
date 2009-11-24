require "openssl"

module Crypto
  # Copyright (c) 2007 Ben Johnson of Binary Logic (binarylogic.com)
  # 
  # Permission is hereby granted, free of charge, to any person obtaining
  # a copy of this software and associated documentation files (the
  # "Software"), to deal in the Software without restriction, including
  # without limitation the rights to use, copy, modify, merge, publish,
  # distribute, sublicense, and/or sell copies of the Software, and to
  # permit persons to whom the Software is furnished to do so, subject to
  # the following conditions:
  # 
  # The above copyright notice and this permission notice shall be
  # included in all copies or substantial portions of the Software.
  # 
  # THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
  # EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
  # MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
  # NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
  # LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
  # OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
  # WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

  # This encryption method is reversible if you have the supplied key. So in order to use this encryption method you must supply it with a key first.
  # In an initializer, or before your application initializes, you should do the following:
  #
  #   Authlogic::CryptoProviders::AES256.key = "my really long and unique key, preferrably a bunch of random characters"
  #
  # My final comment is that this is a strong encryption method, but its main weakness is that its reversible. If you do not need to reverse the hash
  # then you should consider Sha512 or BCrypt instead.
  #
  # Keep your key in a safe place, some even say the key should be stored on a separate server.
  # This won't hurt performance because the only time it will try and access the key on the separate server is during initialization, which only
  # happens once. The reasoning behind this is if someone does compromise your server they won't have the key also. Basically, you don't want to
  # store the key with the lock.
  class AES256
    class << self
      attr_writer :key
  
      def encrypt(*tokens)
        aes.encrypt
        aes.key = @key
        [aes.update(tokens.join) + aes.final].pack("m").chomp
      end
  
      def decrypt(crypted)
        aes.decrypt
        aes.key = @key
        (aes.update(crypted.unpack("m").first) + aes.final)
      rescue OpenSSL::CipherError
        false
      end
  
      def matches?(crypted, *tokens)
        aes.decrypt
        aes.key = @key
        (aes.update(crypted.unpack("m").first) + aes.final) == tokens.join
      rescue OpenSSL::CipherError
        false
      end
  
      private
        def aes
          raise ArgumentError.new("You must provide a key like #{name}.key = my_key before using the #{name}") if @key.blank?
          @aes ||= OpenSSL::Cipher::Cipher.new("AES-256-ECB")
        end
    end
  end
end