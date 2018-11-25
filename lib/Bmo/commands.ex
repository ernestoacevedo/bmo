defmodule Bmo.Commands do
  use Timex
  use Coxir.Commander
  require IEx
  alias Porcelain.Process, as: Proc

  @prefix ","

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
    if message.author.id == "134688787002425344" do
      end_timex = Timex.parse!("2020-09-26 00:00:00", "%Y-%m-%d %H:%M:%S", :strftime)
      start_timex = Timex.now
      diff_in_days = Timex.diff(end_timex, start_timex, :days)
      Message.reply(message, "Lo siento, eres demasiado 👶🏻 para utilizar este comando. Inténtalo en #{diff_in_days} días más.")
    else
      url = "#{Application.fetch_env!(:coxir, :pikasen_url)}#{search}"
      case HTTPoison.get(url) do
        {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
          case Jason.decode(body) do
            {:ok, list} ->
              item = Enum.random(list)
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

  command img(search) do
    url = "https://www.googleapis.com/customsearch/v1"
    headers = []
    opts = [
      params: [
        q: search,
        searchType: "image",
        safe: "high",
        fields: "items(link)",
        cx: Application.fetch_env!(:coxir, :cse_id),
        key: Application.fetch_env!(:coxir, :cse_key),
      ]
    ]

    case HTTPoison.get(url, headers, opts) do
      {:ok, %{status_code: 200, body: body}} ->
        {:ok, res} = Jason.decode(body)
        item = res["items"] |> Enum.random
        Message.reply(message, item["link"])
      {:ok, %{status_code: 400, body: body}} ->
        IO.inspect body
        Message.reply(message, "Ocurrió un error")
      {:error, _} ->
        Message.reply(message, "No encontré nada")
    end
  end

  command gif(search) do
    url = "https://www.googleapis.com/customsearch/v1"
    headers = []
    opts = [
      params: [
        q: search,
        searchType: "image",
        fileType: "gif",
        hq: "animated",
        tbs: "itp:animated",
        safe: "high",
        fields: "items(link)",
        cx: Application.fetch_env!(:coxir, :cse_id),
        key: Application.fetch_env!(:coxir, :cse_key),
      ]
    ]

    case HTTPoison.get(url, headers, opts) do
      {:ok, %{status_code: 200, body: body}} ->
        {:ok, res} = Jason.decode(body)
        item = res["items"] |> Enum.random
        Message.reply(message, item["link"])
      {:ok, %{status_code: 400, body: body}} ->
        IO.inspect body
        Message.reply(message, "Ocurrió un error")
      {:error, _} ->
        Message.reply(message, "No encontré nada")
    end
  end

  command yt(search) do
    url = "https://www.googleapis.com/youtube/v3/search"
    headers = []
    opts = [
      params: [
        key: Application.fetch_env!(:coxir, :cse_key),
        part: "id",
        type: "video",
        order: "relevance",
        maxResults: 15,
        q: search,
      ]
    ]

    case HTTPoison.get(url, headers, opts) do
      {:ok, %{status_code: 200, body: body}} ->
        res = Jason.decode! body
        items = res["items"]
        video_id = Enum.at(items, 0)["id"]["videoId"]
        Message.reply(message, "https://youtu.be/#{video_id}")
      _ ->
        Message.reply(message, "No encontré nada")
    end
  end

  command horoscopo(sign) do
    url = "https://api.adderou.cl/tyaas/"
    case HTTPoison.get(url) do
      {:ok, %{status_code: 200, body: body}} ->
        {:ok, response} = body |> Jason.decode
        prediction = response["horoscopo"] |> Map.get(sign)
        if prediction do
          msg = """
          ❤️ #{prediction["amor"]}\n
          🤒 #{prediction["salud"]}\n
          💰 #{prediction["dinero"]}\n
          🔢 #{prediction["numero"]}\n
          🎨 #{prediction["color"]}\n
          """
          Message.reply(message, msg)
        else
          Message.reply(message, "Ese no es un signo válido")
        end
      {:error, _} ->
        Message.reply(message, "Ocurrió un error")
    end
  end

  command random(options) do
    option = String.split(options, ",") |> Enum.random
    Message.reply(message, "🎲 #{option}")
  end

  command pregunta(question) do
    answer = [
      "En mi opinión, sí",
      "Es cierto",
      "Es decididamente así",
      "Probablemente",
      "Buen pronóstico",
      "Todo apunta a que sí",
      "Sin duda",
      "Sí",
      "Sí - definitivamente",
      "Debes confiar en ello",
      "Respuesta vaga, vuelve a intentarlo",
      "Pregunta en otro momento",
      "Será mejor que no te lo diga ahora",
      "No puedo predecirlo ahora",
      "Concéntrate y vuelve a preguntar",
      "No cuentes con ello",
      "Mi respuesta es no",
      "Mis fuentes me dicen que no",
      "Las perspectivas no son buenas",
      "Muy dudoso"
    ] |> Enum.random
    Message.reply(message, answer)
  end

  command help do
    list = help()
    Message.reply(message, list)
  end

  command ayuda do
    list = help()
    Message.reply(message, list)
  end

  command aiura do
    list = help()
    Message.reply(message, list)
  end

  defp help() do
    list = """
    **,img <algo>** Muestra una imagen al azar.
    **,gif <algo>** Muestra un gif al azar.
    **,pikasen <algo>** Envía una imagen por interno (Utilizar con precaución).
    **,atata** Retorna un atata 🐶.
    **,horoscopo <signo>** Muestra el horóscopo del signo solicitado.
    **,random <opcion1,opcion2>** Escoge una opción al azar.
    """
  end
end
