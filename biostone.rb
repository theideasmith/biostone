require './pp'

module BioS

    class AA < String
        AA_TO_CODON = {
            :phe=>[[:u, :u, :u], [:u, :u, :c]],
            :leu=>
                [[:u, :u, :a],
                [:u, :u, :g],
                [:c, :u, :u],
                [:c, :u, :c],
                [:c, :u, :a],
                [:c, :u, :g]],
            :ser=>
                [[:u, :c, :u],
                [:u, :c, :c],
                [:u, :c, :a],
                [:u, :c, :g],
                [:a, :g, :u],
                [:a, :g, :c]],
            :tyr=> [[:u, :a, :u], [:u, :a, :c]],
            :STOP=> [[:u, :a, :a], [:u, :a, :g], [:u, :g, :a]],
            :cys=> [[:u, :g, :u], [:u, :g, :c]],
            :trp=> [[:u, :g, :g]],
            :pro=> [[:c, :c, :u], [:c, :c, :c], [:c, :c, :a], [:c, :c, :g]],
            :his=> [[:c, :a, :u], [:c, :a, :c]],
            :gln=> [[:c, :a, :a], [:c, :a, :g]],
            :arg=>
                [[:c, :g, :u],
                [:c, :g, :c],
                [:c, :g, :a],
                [:c, :g, :g],
                [:a, :g, :a],
                [:a, :g, :g]],
            :ile=> [[:a, :u, :u], [:a, :u, :c], [:a, :u, :a]],
            :met=> [[:a, :u, :g]],
            :thr=> [[:a, :c, :u], [:a, :c, :c], [:a, :c, :a], [:a, :c, :g]],
            :asn=> [[:a, :a, :u], [:a, :a, :c]],
            :lys=> [[:a, :a, :a], [:a, :a, :g]],
            :val=> [[:g, :u, :u], [:g, :u, :c], [:g, :u, :a], [:g, :u, :g]],
            :ala=> [[:g, :c, :u], [:g, :c, :c], [:g, :c, :a], [:g, :c, :g]],
            :asp=> [[:g, :a, :u], [:g, :a, :c]],
            :glu=> [[:g, :a, :a], [:g, :a, :g]],
            :gly=> [[:g, :g, :u], [:g, :g, :c], [:g, :g, :a], [:g, :g, :g]]
        }

        def bases codon

            res = AA_TO_CODON[self.to_sym].map {|bases|AA.new bases.join} if res
            throw "Invalid codon #{codon} passed"

        end

    end

    class NA < String
        DNA_REGEX = /^[agct]+$/
        RNA_REGEX = /^[agcu]+$/


        CODON_TO_AA_LOOKUP = {
         :u=>
          {:u=>{:u=>:phe, :c=>:phe, :a=>:leu, :g=>:leu},
           :c=>{:u=>:ser, :c=>:ser, :a=>:ser, :g=>:ser},
           :a=>{:u=>:tyr, :c=>:tyr, :a=>:STOP, :g=>:STOP},
           :g=>{:u=>:cys, :c=>:cys, :a=>:STOP, :g=>:trp}},
         :c=>
          {:u=>{:u=>:leu, :c=>:leu, :a=>:leu, :g=>:leu},
           :c=>{:u=>:pro, :c=>:pro, :a=>:pro, :g=>:pro},
           :a=>{:u=>:his, :c=>:his, :a=>:gln, :g=>:gln},
           :g=>{:u=>:arg, :c=>:arg, :a=>:arg, :g=>:arg}},
         :a=>
          {:u=>{:u=>:ile, :c=>:ile, :a=>:ile, :g=>:met},
           :c=>{:u=>:thr, :c=>:thr, :a=>:thr, :g=>:thr},
           :a=>{:u=>:asn, :c=>:asn, :a=>:lys, :g=>:lys},
           :g=>{:u=>:ser, :c=>:ser, :a=>:arg, :g=>:arg}},
         :g=>
          {:u=>{:u=>:val, :c=>:val, :a=>:val, :g=>:val},
           :c=>{:u=>:ala, :c=>:ala, :a=>:ala, :g=>:ala},
           :a=>{:u=>:asp, :c=>:asp, :a=>:glu, :g=>:glu},
           :g=>{:u=>:gly, :c=>:gly, :a=>:gly, :g=>:gly}}
        }

        DNA_MATCH = {
            'c' => 'g',
            'g' => 'c',
            'a' => 't',
            't' => 'a'
        }

        RNA_MATCH = {
            'c' => 'g',
            'g' => 'c',
            'a' => 'u',
            'u' => 'a'
        }

        DNA_TO_RNA_MATCH = {

            'c' => 'g',
            'g' => 'c',
            'a' => 'a',
            't' => 'u'
        }

        RNA_TO_DNA_MATCH = {

            'c' => 'g',
            'g' => 'c',
            'a' => 'a',
            'u' => 't'
        }
        def self._complement(seq, matcher)
            res = ''
            for pos in 0..seq.length - 1
                nucleotide = seq[pos]
                fail ArgumentError, "Invalid nucleotide base #{nucleotide} passed. Can only be #{matcher.values}" if matcher[nucleotide].nil?
                res += matcher[nucleotide]
            end
            res
        end

        def annealing_temp
            n = length.to_f
            gcs = scan(/[gc]/).length.to_f
            percentage_GC = gcs / n
            tm_celc = 81.5 + (0.41 * percentage_GC) - (675 / n)
            tm_celc
        end

        def +(sequence)
            return unless sequence.class <= String
            res = self.class.new super sequence
            res
        end

        def reverse
            self.class.new super
        end

        def dna?
            self[DNA_REGEX] != nil
        end

        def rna?
            self[RNA_REGEX] != nil
        end

        def type_of
            if rna? self
                :rna
            elsif dna? self
                :dna
            end
        end

        def stringify
            self.scan(/.{3}/).join("")
        end

    end

    class RNA < NA
        def self.from_file file
            RNA.new (File.read seq).gsub("\n", '') if File.exist? seq
        end


        def complement
           RNA.new (NA._complement self, NA::RNA_MATCH)
           rescue Exception => e
               puts 'Error while complementing rna'
               puts e.message
        end

        def translate
            if self.dna? then return [] end
            res = []
            len = self.length
            self.scan(/.{3}/).each do |codon|
                a = codon[0].to_sym
                b = codon[1].to_sym
                c = codon[2].to_sym
                res.push AA.new NA::CODON_TO_AA_LOOKUP[a][b][c].to_s
            end
            res
        end

        def reverse_transcribe
           DNA.new (NA._complement self, NA::RNA_TO_DNA_MATCH)
           rescue Exception => e
               puts 'Error while reverse transcribing dna'
               puts e.message
        end
    end

    class DNA < NA
        def self.from_file file
            DNA.new (File.read file).gsub("\n", '') if File.exist? file
        end

        def initialize(str)
            super str
            self.downcase!
        end

        def complement
           DNA.new (NA._complement self, NA::DNA_MATCH)
           rescue Exception => e
               puts 'Error while complementing dna'
               puts e.message
        end

        def transcribe
            RNA.new (NA._complement self, NA::DNA_TO_RNA_MATCH)
           rescue Exception => e
               puts 'Error while transcribing dna'
               puts e.message
        end

    end

    class BioBrick
        attr_accessor :data

        def initialize(data)
            data[:sequence] = Sequence::DNA.new load_sequence(data[:sequence])
            @data = data
        end

        def load_sequence(seq)
            res = if File.exist? seq
                      File.read seq
                  else
                      seq
                end
            res.gsub("\n", '')
        end

        def value
            @data
        end

        def sequence
            @data[:sequence]
        end
    end

    class Plasmid < Array
        attr_accessor :data
        def initialize(arr)
            super arr
        end

        def sequence
            res = ''
            each do |seq|
                res += seq.sequence
            end
            Sequence::DNA.new res
        end

        def value
            pp (map(&:value))
        end
    end
end


class String
    def to_dna
        BioS::DNA.new self
    end

    def to_rna r
        BioS::RNA.new self
    end

    def to_aa a
        BioS::AA.new self
    end
end

def biobrick(brick)
    BioS::BioBrick.new(brick)
end

def plasmid(brick)
    BioS::Plasmid.new(brick)
end
