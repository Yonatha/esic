require 'pdf-reader'
require "awesome_print"
require 'active_support/inflector'

class EcosistemaPDF

  def self.ler_arquivo(caminho)
    reader = PDF::Reader.new(caminho)

    PDF::Reader.open(caminho) do |reader|
      reader.pages.each do |page|
        x = page.text
        open('tmp/outputread.txt', 'a') {|f|
          f.puts x.mb_chars.normalize(:kd).gsub(/[^\x00-\x7F]/n, '').downcase.to_s
        }
      end
    end

    @resumo_dos_saldos = {}
    File.open('tmp/outputread.txt', 'r') do |f1|
      while line = f1.gets

        # Condominio
        condominio = line.partition('cnpj/cpf:')[2]
        unless condominio == ''
          @resumo_dos_saldos[:cnpj] = condominio.split(" ")[0]
        end

        # Período
        periodo = line.partition('periodo de ')[2]
        unless periodo == ''
          periodo = periodo.split(/\n/)[0].gsub(" ", "").split("a")
          @resumo_dos_saldos[:periodo_inicial] = periodo[0]
          @resumo_dos_saldos[:periodo_final] = periodo[1]
        end

        # Valores totais do Balancete demonstrativo
        total = line.partition('saldfinal')[2]
        unless total == ''
          total = total.split(" ")
          @resumo_dos_saldos[:saldo_anterior] = total[0].gsub!(/[^0-9A-Za-z]/, '').gsub('o', "0").to_f
          @resumo_dos_saldos[:receitas] = total[1].gsub!(/[^0-9A-Za-z]/, '').gsub('o', "0").to_f
          @resumo_dos_saldos[:despesas] = total[2].gsub!(/[^0-9A-Za-z]/, '').gsub('o', "0").to_f
          @resumo_dos_saldos[:saldo_atual] = total[3].gsub!(/[^0-9A-Za-z]/, '').gsub('o', "0").to_f
        end

      end
    end

    ap @resumo_dos_saldos

    return @resumo_dos_saldos
  end
end
