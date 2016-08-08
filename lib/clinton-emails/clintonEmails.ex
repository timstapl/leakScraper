defmodule LeakScraper.ClintonEmails do

  def main(first, last) do
    IO.puts "Scraping from #{first} to #{last}"
    # early stage workflow, overly procedural, just hammering this out
    # currently only using one process, and looping through ids
    # will update this to use the worker model in the future.
    if first > 0 and last < 30322 do
      first..last
        |> Enum.map(&workflow/1)
    end

  end

  defp workflow(id) do
    id
      |> build_url
      |> scrape_email
      |> (&prep_data(&1, id)).()
      |> save_data
      |> IO.inspect
  end

  defp build_url(id) do
    "https://wikileaks.org/clinton-emails/emailid/#{id}"
  end

  defp scrape_email(url) do
    HTTPoison.get!(url).body
  end

  defp prep_data(scrape, id) do
    {:ok, timestamp_regex} = Regex.compile("[0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}")
    pdf_prefix = "https://www.wikileaks.org"

    %{
      :id           => id,
      :subject      => Floki.find(scrape, "h2") |> Floki.text,
      :from         => Floki.find(scrape, "#header > span") |> List.first |> Floki.text,
      :to           => Floki.find(scrape, "#header > span") |> List.last |> Floki.text,
      :timestamp    => Floki.find(scrape, "#header") |> Floki.text |> (&Regex.run(timestamp_regex, &1)).() |> List.first,
      :body         => Floki.find(scrape, "div.email-content") |> Floki.text,
      :raw          => Floki.find(scrape, "div.active") |> Floki.filter_out("h2") |> Floki.raw_html,
      :pdf          => pdf_prefix <> ( Floki.find(scrape, "div.tab-pane > p > a") |> Floki.attribute("href") |> List.first),
      :attachments  => "todo"
    }
  end

  defp save_data(data) do

    data

  end

end
