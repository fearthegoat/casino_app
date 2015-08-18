  task :ping_server do
    `curl https://casino-app.herokuapp.com/`
  end