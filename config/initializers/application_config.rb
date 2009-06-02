config ={
  'development' => { :unzip => '/usr/bin/unzip',
                     :unzip_params => '-o'
                   },

  'test'        => { :unzip => '/usr/bin/unzip',
                     :unzip_params => '-o'
                   },
}

APP_CONFIG = config[RAILS_ENV]