defmodule Bmo.Commands do
  use Coxir.Commander

  @prefix ";"

  command greet do
    Message.reply(message, "hola po")
  end

end
