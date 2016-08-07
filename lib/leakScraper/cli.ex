defmodule LeakScraper.CLI do

  def main(args) do
    args
    |> parse_args
    |> process
  end

  defp process(:help) do
    IO.puts """
      usage:
        ./leakScraper --dataset=clinton-emails --first=1 --last=30322
        ./leakScraper -d clinton-emails -f 1 -l 30322

      required flags:
        --dataset || -d  => dataset to scrape from wikileaks. Values are formatted as their URLs are (clinton-emails, dnc-emails, etc)
        --first   || -f  => which item ID to begin the scrape from (inclusive)
        --last    || -l  => which item ID to end the scrape on (inclusive)
    """
    System.halt(0)
  end

  defp process(dataset, first, last) do
    IO.puts "Scraping #{dataset} entries from #{first} to #{last}"

    # temp, halting system. This will be replaced by a cleanup function in the future.
    System.halt(0)
  end

  defp parse_args(args) do
    # TODO need to add a verbose mode and a test mode.
    parse = OptionParser.parse(args,
      switches: [dataset: :string, first: :integer, last: :integer],
      aliases: [d: :dataset, f: :first, l: :last ]
    )
    case parse do
      {[dataset: dataset, first: first, last: last], _, _} -> process(dataset, first, last)
      {_,_,_} -> process(:help)
    end
  end

end
