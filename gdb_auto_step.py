import gdb

def auto_step(event):
	# gdb.execute("x/10i $eip-10")
	gdb.execute("disassemble")
	gdb.execute("x/i $eip")
	gdb.execute("echo stack\\n")
	gdb.execute("i r ebp\ni r esp")
	gdb.execute("x/8x $sp")
	gdb.execute("echo Help: i r -> rejestry, clear nazwabreakpointa\\n")

gdb.events.stop.connect(auto_step)
