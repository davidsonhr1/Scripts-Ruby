# GetLycris.rb
require 'rubygems'
require 'vagalume'
require 'builder'

args = {}

ARGV.each do |arg|
  match = /--(?<key>.*?)=(?<value>.*)/.match(arg)
    args[match[:key]] = match[:value] # e.x args['artista'] = 'Fernandinho'
end

    artista = args['artista']
    musica = args['musica']
    lingua = args['lingua']

    result = Vagalume.find(artista, musica)

    puts result.status # Status do retorno "song_notfound" ou "notfound"

    song = result.song
    song.id
    song.name
    song.language
    song.url
    song.lyric

    artist = result.artist
    artist.id
    artist.name
    artist.url

    #puts result.inspect

    if lingua == "EN"
      resultado = result
      musica = song.lyric
     elsif lingua == "PT"
      resultado = result
      musica = song.lyric
    elsif lingua == "EN/PT"
      resultado = result.translations.with_language(Vagalume::Language::PORTUGUESE) # retorna a musica em português
      musica = resultado.lyric
    end 

    delimiter = "

"

    versos = musica.split(delimiter)

    xml = Builder::XmlMarkup.new( :indent => 2 )
    xml.instruct! :xml, :encoding => "UTF-8"
    xml.song :xmlns => "www.adcasteloforte.com.br", :version => "1.0", :createdIn => "ADCF", :modifiedIn => "", :modifiedDate => "" do |s|
        xml.properties do |p|
          xml.titles do |t|
            t.title song.name
          end
          xml.authors do |a|
            a.author artist.name
          end
        end
        xml.lyrics do |p|
            for v in 0..versos.length
                  xml.verse :name => "v#{v}" do |t|
                      t.lines musica.split(delimiter)[v]
                  end
            end #for

          end  #lyrics

      end

    #puts xml.inspect

    file = File.new("#{artist.name} - #{song.name}.xml", "wb")
    xmls = Builder::XmlMarkup.new target: file
      file.write(xml)
    file.close


