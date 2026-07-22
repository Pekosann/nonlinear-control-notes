# Citations from a BibTeX/BibLaTeX file, Pandoc style.
#
#   Write  [@henson1990]  in a note  ->  renders as [1] linking to the reference
#   list, which is appended to the page under a "Referensi" heading.
#   Several keys at once:  [@henson1990; @seborg]  ->  [1, 2]
#
# The .bib lives in _bibliography/references.bib (any .bib in that folder is
# read). Export it straight from Zotero — BibLaTeX or BibTeX both work.
# Numbering is per page, in order of first appearance.
#
# This needs a real plugin, which is why the site is built by our own GitHub
# Actions workflow instead of GitHub's built-in Jekyll (that one runs in safe
# mode and ignores _plugins/).

require 'strscan'

module Bibliography
  BIB_DIR = '_bibliography'.freeze
  # [@key] or [@key1; @key2] — key charset matches what Zotero generates.
  CITE_RE = /\[@([A-Za-z0-9_:.\-]+(?:\s*;\s*@[A-Za-z0-9_:.\-]+)*)\]/

  class << self
    attr_accessor :entries

    # ---------------------------------------------------------------- parse --

    def load(site)
      @entries = {}
      dir = File.join(site.source, BIB_DIR)
      return @entries unless Dir.exist?(dir)

      Dir.glob(File.join(dir, '*.bib')).sort.each do |path|
        text = File.read(path, encoding: 'UTF-8')
        parse(text).each { |k, v| @entries[k] = v }
      end
      Jekyll.logger.info 'Bibliography:', "#{@entries.size} entries from #{BIB_DIR}/"
      @entries
    end

    def parse(text)
      out = {}
      s = StringScanner.new(text)
      while s.skip_until(/@(\w+)\s*\{\s*/)
        type = s[1].downcase
        next if %w[comment preamble string].include?(type)

        key = s.scan(/[^,\s}]+/)
        next if key.nil? || key.empty?
        s.skip(/\s*,\s*/)

        fields = { 'type' => type }
        loop do
          break if s.skip(/\s*\}/) || s.eos?
          name = s.scan(/\s*([A-Za-z_][\w\-]*)\s*=\s*/)
          break if name.nil?
          fields[name.strip.chomp('=').strip.downcase] = read_value(s)
          s.skip(/\s*,\s*/)
        end
        out[key] = fields
      end
      out
    end

    # Reads one field value: {braced}, "quoted", or a bare token.
    def read_value(s)
      if s.skip(/\{/)
        depth = 1
        buf = +''
        until s.eos? || depth.zero?
          c = s.getch
          depth += 1 if c == '{'
          depth -= 1 if c == '}'
          buf << c unless depth.zero? && c == '}'
        end
        clean(buf)
      elsif s.skip(/"/)
        clean(s.scan(/(?:[^"\\]|\\.)*/).to_s).tap { s.skip(/"/) }
      else
        clean(s.scan(/[^,}\s]*/).to_s)
      end
    end

    # BibTeX braces/escapes -> plain text.
    def clean(str)
      str.to_s
         .gsub(/[{}]/, '')
         .gsub(/\\&/, '&')
         .gsub(/\\%/, '%')
         .gsub(/\\_/, '_')
         .gsub(/\\textendash\b/, '–')
         .gsub(/~/, ' ')
         .gsub(/\s+/, ' ')
         .strip
    end

    # ------------------------------------------------------------- format ----

    def year(e)
      raw = e['date'] || e['year'] || ''
      m = raw.match(/(\d{4})/)
      m ? m[1] : 'n.d.'
    end

    # "Guan, Hongwei and Ye, Lingjian" -> "Guan, H., & Ye, L."
    def authors(e)
      raw = e['author'] || e['editor']
      return nil if raw.nil? || raw.empty?

      people = raw.split(/\s+and\s+/i).map { |n| abbreviate(n) }
      case people.size
      when 1 then people[0]
      when 2 then "#{people[0]} & #{people[1]}"
      else "#{people[0..-2].join(', ')}, & #{people[-1]}"
      end
    end

    def abbreviate(name)
      name = name.strip
      if name.include?(',')
        last, given = name.split(',', 2)
      else
        parts = name.split(/\s+/)
        last = parts.pop
        given = parts.join(' ')
      end
      initials = given.to_s.split(/[\s.\-]+/).reject(&:empty?)
                      .map { |g| "#{g[0].upcase}." }.join(' ')
      initials.empty? ? last.strip : "#{last.strip}, #{initials}"
    end

    def esc(str)
      str.to_s.gsub('&', '&amp;').gsub('<', '&lt;').gsub('>', '&gt;')
    end

    def render_entry(key, e)
      return "<span class=\"cite-missing\">#{esc(key)} — tidak ada di references.bib</span>" if e.nil?

      parts = []
      a = authors(e)
      parts << "#{esc(a)} (#{year(e)})." if a
      parts << "#{esc(e['title'])}." if e['title']

      journal = e['journaltitle'] || e['journal'] || e['booktitle']
      if journal
        loc = +"<em>#{esc(journal)}</em>"
        loc << ", #{esc(e['volume'])}" if e['volume']
        loc << "(#{esc(e['number'])})" if e['number']
        loc << ", #{esc(e['pages'].to_s.gsub('--', '–'))}" if e['pages']
        parts << "#{loc}."
      elsif e['publisher']
        parts << "#{esc(e['publisher'])}."
      elsif e['organization']
        parts << "#{esc(e['organization'])}."
      end

      if e['doi'] && !e['doi'].empty?
        url = "https://doi.org/#{e['doi']}"
        parts << "<a href=\"#{esc(url)}\">#{esc(url)}</a>"
      elsif e['url'] && !e['url'].empty?
        parts << "<a href=\"#{esc(e['url'])}\">#{esc(e['url'])}</a>"
      end

      parts.join(' ')
    end

    # ------------------------------------------------------------- process ---

    def process(doc)
      content = doc.content
      return unless content.is_a?(String) && content =~ CITE_RE

      order = []   # keys, in order of first appearance on this page

      content = content.gsub(CITE_RE) do
        keys = Regexp.last_match(1).split(';').map { |k| k.strip.sub(/\A@/, '') }
        nums = keys.map do |k|
          unless order.include?(k)
            order << k
            unless entries.key?(k)
              Jekyll.logger.warn 'Bibliography:', "unknown key [@#{k}] in #{doc.relative_path}"
            end
          end
          n = order.index(k) + 1
          "<a href=\"##{'ref-' + k}\" class=\"cite\">#{n}</a>"
        end
        "[#{nums.join(', ')}]"
      end

      items = order.map do |k|
        "  <li id=\"ref-#{k}\">#{render_entry(k, entries[k])}</li>"
      end

      content += "\n\n<h2 id=\"referensi\">Referensi</h2>\n" \
                 "<ol class=\"bibliography\">\n#{items.join("\n")}\n</ol>\n"

      doc.content = content
    end
  end
end

Jekyll::Hooks.register :site, :post_read do |site|
  Bibliography.load(site)
end

Jekyll::Hooks.register [:pages, :documents], :pre_render do |doc|
  Bibliography.process(doc)
end
