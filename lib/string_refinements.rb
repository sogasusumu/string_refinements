require "string_refinements/version"
require 'charwidth/string'
module StringRefinements
  refine String do
    # @return [String] 改行コードを\nに、複数回繰り返す場合は単一の\n、先頭末尾の改行コードは削除される
    def refine_line_breaks
      gsub(/\R+/, "\n").chomp.strip
    end

    # @return [String] 空白を半角スペースに統一、複数回繰り返す場合は単一の半角スペース、先頭末尾の半角スペースと改行コードは削除される
    def refine_whitespaces
      gsub(/　/, ' ').gsub(/\s+/, ' ').chomp.strip
    end

    # @return [String] 空白・改行を単一に、空白のみの行は削除する。
    def refine
      refine_line_breaks.split("\n").map(&:refine_whitespaces).reject { |char| char == '' }.join("\n")
    end

    # @retirn [String] エンコードされた日本語をデコードする。
    # @param [char_code] String 変換したい文字コード 指定しない場合はutf-8
    def decode_to_jp(char_code = 'UTF-8')
      URI.decode(self).force_encoding(char_code)
    end

    # @return [String] 全角英数字を半角英数字に、半角カナを全角カナに変換する
    def normalize
      normalize_charwidth
    end
  end
end
