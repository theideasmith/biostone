require_relative '../biostone'
GENOMICON_PREFIX = "agggtctcagat"
GENOMICON_SUFFIX = "gccgactctgg"
#Primers for PCR of SulA Promoter
sul_A = "ggggttgatctttgttgtcactggatgtactgtacatccatacagtaactcac"
fwd_primer = (GENOMICON_PREFIX + sul_A[0,20]).to_dna
rvs_primer = (sul_A[-16,16].to_dna.complement + GENOMICON_SUFFIX).reverse

puts "Forward: #{fwd_primer.stringify}\nReverse: #{rvs_primer.stringify}\n"
puts "-" * 80
full = (GENOMICON_PREFIX + sul_A + GENOMICON_SUFFIX).to_dna
puts "Full Promoter: #{full.stringify}\nLength: #{full.length}"


#Primers for PCR of Melanin
# => I'm not sure we'll be doing melanin, but this is good for if we do
=begin
file = ((File.dirname File.expand_path(__FILE__)) + "/../parts/melanin.txt").to_s
melanin = BioS::DNA.from_file file
melanin_fwd_primer = ("agggtctcagat" + melanin[0,20]).to_dna
melanin_rvs_primer = (melanin[-18,18].to_dna.complement + "gccgactctgg").reverse

puts "Melanin Forward: #{melanin_fwd_primer.stringify}\nMelanin Reverse: #{melanin_rvs_primer.stringify}\n"
puts "Melanin FWD Temp: #{melanin_fwd_primer.annealing_temp}\nMelanin RVS Temp: #{melanin_rvs_primer.annealing_temp}\n"
=end
