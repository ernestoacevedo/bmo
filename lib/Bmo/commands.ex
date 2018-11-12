defmodule Bmo.Commands do
  use Coxir.Commander
  alias Porcelain.Process, as: Proc

  defp url_stream(url, options) do
    %Proc{out: youtube} =
      Porcelain.spawn(Application.fetch_env!(:coxir, :youtube_dl),
        ["-q", "-f", "bestaudio", "-o", "-", url], [out: :stream])
    io_data_stream(youtube, options)
  end

  defp io_data_stream(data, options) do
    IO.inspect data
    volume = (options[:vol] || 100) / 100
    opts = [in: data, out: :stream]
    %Proc{out: audio_stream} =
      Porcelain.spawn(Application.fetch_env!(:coxir, :ffmpeg),
        ["-hide_banner", "-loglevel", "quiet", "-i","pipe:0",
         "-f", "data", "-map", "0:a", "-ar", "48k", "-ac", "2",
         "-af", "volume=#{volume}",
         "-acodec", "libopus", "-b:a", "128k", "pipe:1"], opts)
    IO.inspect audio_stream
    audio_stream
  end

  @prefix ","

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
    stream = url_stream(term, %{vol: 100})

    message
    |> join

    member.voice
    |> Voice.play(stream)
  end

  command stop do
    member.voice
    |> Voice.stop_playing
  end

  command atata do
    msg = ~w(atatata atatatatatatata aTatAtAa
    https://www.youtube.com/watch?v=0jyAmP3yGuM https://www.youtube.com/watch?v=0oTgA4RVx0E
    https://www.youtube.com/watch?v=L5P9IeMMoHI https://www.youtube.com/watch?v=_Z7UJPsrAT0
    https://www.youtube.com/watch?v=Bxbg7zaY4MU https://www.youtube.com/watch?v=rEDC5aVwna0
    https://www.youtube.com/watch?v=ZUKVH44Vl1k)
    |> Enum.random
    Message.reply(message, msg)
  end

  command pikasen(search) do
    url = "#{Application.fetch_env!(:coxir, :pikasen_url)}#{search}"
    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        case Jason.decode(body) do
          {:ok, list} ->
            item = List.first(list)
            message = "#{Application.fetch_env!(:coxir, :pikasen_cdn)}#{item["directory"]}/#{item["image"]}"
            User.send_message(author, "😏 #{message}")
          {:error, _} ->
            User.send_message(author, "No encontré resultados 😟")
        end
      {:ok, %HTTPoison.Response{status_code: 404}} ->
        User.send_message(author, "No encontré resultados 😟")
      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.inspect reason
    end
  end
end
