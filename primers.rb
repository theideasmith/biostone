require './biostone'

#Regular LacZ
sul_A = "ggggttgatctttgttgtcactggatgtactgtacatccatacagtaactcac"
fwd_primer = ("agggtctcagat" + sul_A[0,20]).to_dna
rvs_primer = (sul_A[-16,16].to_dna.complement_dna + "gccgactctgg").reverse


#Regular
sul_A = "ggggttgatctttgttgtcactggatgtactgtacatccatacagtaactcac"
fwd_primer = ("agggtctcagat" + sul_A[0,20]).to_dna
rvs_primer = (sul_A[-16,16].to_dna.complement_dna + "gccgactctgg").reverse

puts "Forward: #{fwd_primer.stringify}\nReverse: #{rvs_primer.stringify}\n"
puts "-" * 80

melanin = BioLib::DNA.from_file "./melanin.txt"
melanin_fwd_primer = "agggtctcagat" + melanin[0,20]
melanin_rvs_primer = (melanin[-18,18].to_dna.complement_dna + "gccgactctgg").reverse

puts "Melanin Forward: #{melanin_fwd_primer.stringify}\nMelanin Reverse: #{melanin_rvs_primer.stringify}\n"
puts "Melanin FWD Temp: #{melanin_fwd_primer.tm}\nMelanin RVS Temp: #{melanin_rvs_primer.tm}\n"
