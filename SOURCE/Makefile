CLIPROOT = /usr/local/clip
LANG = en_EN.CP437


CLIP	= $(CLIPROOT)/bin/clip
MAKESLIB = $(CLIPROOT)/bin/clip_makeslib
MAKELIB = $(CLIPROOT)/bin/clip_makelib
CLIPFLAGS = -a -O 

OBJS  = r_hcode.o r_printr.o r_quikr.o r_repold.o r_report.o s_1label.o s_2dbrz.o s_aaskip.o s_abort.o s_achoi.o s_addsp.o s_aextra.o s_aftype.o s_akount.o s_aleng.o s_allbut.o s_amsg.o s_amsort.o s_amstat.o s_append.o s_appt.o s_arrang.o s_ascii.o s_astats.o s_at2c.o s_att.o s_attrib.o s_bdelim.o s_begend.o s_bigel.o s_blanks.o s_bldar.o s_bldbf.o s_bldndx.o s_bom.o s_boxes.o s_boyear.o s_brsdf.o s_build.o s_bxx.o s_calck.o s_calcvw.o s_centr.o s_clab.o s_cls.o s_colpik.o s_copyf.o s_copy.o s_crunch.o s_ctrlw.o s_cvtdel.o s_datcal.o s_datek.o s_datvw.o s_daysin.o s_dbarr.o s_dbstat.o s_delar.o s_delet.o s_doyear.o s_dpops.o s_dtdiff.o s_dtow.o s_duph.o s_dup.o s_editm.o s_editmv.o s_edit.o s_edpict.o s_endsw.o s_enhan.o s_evalq.o s_export.o s_fform.o s_fields.o s_filein.o s_filer.o s_fillar.o s_fm2n.o s_fm2p.o s_forml.o s_freadl.o s_freq.o s_fulld.o s_gened.o s_genva.o s_getcal.o s_getdat.o s_getdfp.o s_getkey.o s_getman.o s_globr.o s_hardc.o s_helpm.o s_help.o s_hplas.o s_init.o s_inlook.o s_isload.o s_ispart.o s_isvalf.o s_kbdesc.o s_list.o s_ljust.o s_lotmen.o s_mailm.o s_makeb.o s_mchoi.o s_meas.o s_menuv.o s_messyn.o s_mfld.o s_mfldt.o s_modify.o s_moose.o s_msg.o s_mulmyn.o s_nbr2st.o s_nkey.o s_notdup.o s_nozdiv.o s_oner.o s_openin.o s_pcsel.o s_picknd.o s_plsw.o s_popdir.o s_popex.o s_popord.o s_popr.o s_popupk.o s_popvw.o s_pread.o s_prnpor.o s_prntf.o s_prnt.o s_prog.o s_proper.o s_pseek.o s_pulldn.o s_purgem.o s_query.o s_readrs.o s_rjust.o s_rmenu2.o s_rread.o s_saddr.o s_scmod.o s_screen.o s_scroll.o s_search.o s_setcen.o s_setcol.o s_setdat.o s_setex.o s_setkey.o s_sfilok.o s_smalk.o s_smal.o s_smgets.o s_snetu.o s_sreclo.o s_stan.o s_starts.o s_stod.o s_stretc.o s_strpat.o s_strpul.o s_subplu.o s_sumav.o s_super.o s_tabmen.o s_tagam.o s_taga.o s_tagf.o s_tag.o s_takeout.o s_time.o s_todo.o s_trueva.o s_unbox.o s_uniqf.o s_unsel.o s_var2.o s_varlen.o s_viewp.o s_vmemo.o s_vview.o s_wild.o s_womon.o s_woyear.o s_writef.o s_xbxx.o

.SUFFIXES: .prg .o .po

all: libsup.so libsup.a 

clean:
	rm -rf  *.o *.c *.a *.so *.pa *.log  *.b  *.bak *~ core* *core init test

install:
	cp libsuper.so $(CLIPROOT)/lib/libsuper.so
	cp libsuper.a  $(CLIPROOT)/lib/libsuper.a
	ln -s $(CLIPROOT)/lib/libsuper.a /usr/lib/libsuper.a
	ln -s $(CLIPROOT)/lib/libsuper.so /usr/lib/libsuper.so

libsup.so: $(OBJS)
	$(MAKESLIB)  libsuper $(OBJS)
	
libsup.a: $(OBJS)
	$(MAKELIB)   libsuper.a $(OBJS)

.prg.o:
	$(CLIP) $(CLIPFLAGS) $<

.prg.po:
	$(CLIP) $(CLIPFLAGS) -p $<

