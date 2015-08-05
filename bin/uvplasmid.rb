require '../biostone'

MELANIN = biobrick({
	src: "BBa_K274001",
	name: "Melanin Pigment",
	sequence: "./parts/melanin_pigment.txt"
})

VIO_OPERON = biobrick({
	src: "BBa_K274002",
	name: "Violacein Operon A - E",
	sequence: "./parts/vio_operon.txt"
})

SUL_A = biobrick({
	src: "BBa_K518010",
	name: "SulA Promoter",
	sequence: "gggttgatctttgttgtcactggatgtactgtacatccatacagtaactcac",
	type: :promoter
})

RBS = biobrick({
	src: "BBa_B0034",
	name: "LacZ RBS",
	sequence: "aaagaggagaaa",
	type: :rbs
})

LACZ_FULL = biobrick({
	src: "BBa_I732017",
	name: "LacZ Full",
	sequence: "./parts/lacz_full.txt",
	type: :reporter
})

LACZ_ALPHA = biobrick({
	src: "BBa_E0033",
	name: "LacZ Alpha",
	sequence: "./parts/lacz_alpha.txt",
	type: :reporter
})

TERMINATOR = biobrick({
	src: nil,
	name: "LacZ Terminator",
	sequence: "caaaaataa",
	type: :terminator
})

PLASMID = plasmid([
		SUL_A,
		RBS,
		LACZ_ALPHA,
		TERMINATOR
	])

PRIMER_LEN = 20
PLASMID_STRING = PLASMID.sequence
PRIMER_OVERHANG_5_3 = "ag" + "ggtctca" + "gatg"
PRIMER_OVERHANG_3_5 = "tc" + "actctgg" + "gccg"
PRIMER_FWD = BioS::DNA.new(
	PRIMER_OVERHANG_5_3 + PLASMID_STRING[ 0,PRIMER_LEN ]
	)
PRIMER_RVS = BioS::DNA.new(
	(PLASMID_STRING[ -PRIMER_LEN, PRIMER_LEN ].complement +
			  PRIMER_OVERHANG_3_5).reverse
	)

PRIMERS = {
	forward:PRIMER_FWD,
	backward:PRIMER_RVS,
	temp_celc_fwd: PRIMER_FWD.annealing_temp,
	temp_celc_rvs: PRIMER_RVS.annealing_temp
}


if ARGV.include? "--verbose"
	puts "PLASMID: "
	puts PLASMID.value
	puts "PRIMERS:\n#{pp PRIMERS}"
	puts "PROTEIN:\n#{pp PLASMID_STRING.transcribe.translate}"
else
	puts PLASMID.sequence
end
