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

end
