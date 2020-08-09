require 'nokogiri'
require "open-uri"
require 'csv'

def scraper
    puts "Scraping..."
    archivo = "confesiones.csv"
    CSV.open(archivo, "wb") do |csv|
        csv << ["Autor","Fecha","Hora","nrolikes","nrodislikes","nroComentarios","texto"]
        #Se obtienen 10 paginas cada una con 15 confesiones
        (1..10).each do |i|
            url = "https://confiesalo.net/?page=#{i}"
            page = open(url).read
            parsed_page = Nokogiri::HTML(page)
            confession_cards = parsed_page.css('div.infinite-item')
            confession_cards.each do |confession_card|
                autor = confession_card.css('span.meta__author').at_css('a').text.chomp(" - ")
                fecha_hora = confession_card.css('span.meta__date').text.strip
                fecha_hora = fecha_hora[2..fecha_hora.length - 1]
                fecha_hora = fecha_hora.split(",")
                fecha = fecha_hora.slice(0)+fecha_hora.slice(1)
                hora = fecha_hora.slice(2).strip
                comentarios = confession_card.css('span.meta__comments').text.strip
                comentarios = comentarios[2..comentarios.length-1]
                if comentarios.to_i == 0
                    comentarios = "0"
                end
                texto = confession_card.css('div.post-content-text').text.strip
                likes = confession_card.css('div.read-more').css('span')[1].text
                if likes.to_i == 0
                    likes = "0"
                end
                dislikes = confession_card.css('div.read-more').css('span')[3].text
                if dislikes.to_i == 0
                    dislikes = "0"
                end
                
                #puts "#{autor},#{fecha},#{hora},#{likes},#{dislikes},#{comentarios},#{texto}"
                csv << [autor,fecha,hora,likes,comentarios,texto]
            end
        end
        puts "CSV file generated successfully"
    end
end

scraper