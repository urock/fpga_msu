TOP_FILE = book
FILES = include/settings.tex \
		$(TOP_FILE).tex \
		01-intro/01_doc.tex \
		02-vhdl_basics/02_doc.tex \
		02-vhdl_basics/lab2-1/src/adder_tb_simple.vhd \
		03-vhdl_modeling/03_doc.tex \
		03-vhdl_modeling/lab3-0.tex \
		03-vhdl_modeling/lab3-1.tex \
		03-vhdl_modeling/lab3-1/src/g_inc.vhd \
		04-comb_elements/04_doc.tex \
		05-sequential_elements/05_doc.tex \
		06-fpga_architecture/06_doc.tex \
		07-pipelines/07_doc.tex \
		08-state_machines/08_doc.tex \
		09-bram/09_doc.tex \
		10-fifo/10_doc.tex \
		11-uart_data_transfer/11_doc.tex \
		12-hardware_debug/12_doc.tex


# all: $(TOP_FILE).dvi $(TOP_FILE).pdf
all: $(TOP_FILE).pdf

# $(TOP_FILE).dvi: $(FILES)
# 	latex $(TOP_FILE).tex && latex $(TOP_FILE).tex


# $(TOP_FILE).pdf: $(TOP_FILE).dvi
$(TOP_FILE).pdf: $(FILES)	
	pdflatex $(TOP_FILE).tex && pdflatex $(TOP_FILE).tex


clean:	
	# rm *.aux
	# rm */*.aux
	# rm $(TOP_FILE).dvi $(TOP_FILE).idx $(TOP_FILE).log $(TOP_FILE).toc
	rm *.pdf