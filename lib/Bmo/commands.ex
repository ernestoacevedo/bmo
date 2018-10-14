defmodule Bmo.Commands do
  use Coxir.Commander

  @prefix ";"

  command greet do
    Message.reply(message, "hola po")
  end

  command join do
    member.voice
    |> Voice.join
  end

  command leave do
    member.voice
    |> Voice.leave
  end

  command play(term) do
    IO.puts term
    message
    |> join

    member.voice
    |> Voice.play(term)
  end

  command stop do
    member.voice
    |> Voice.stop_playing
  end

end
