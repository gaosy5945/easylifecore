package com.amarsoft.app.als.formatdoc.currentresearchdoc;

import java.io.Serializable;
import com.amarsoft.app.als.formatdoc.DocExtClass;
import com.amarsoft.biz.formatdoc.model.FormatDocData;
import com.amarsoft.are.ARE;

public class CR_130 extends FormatDocData implements Serializable {
	private static final long serialVersionUID = 1L;

    private String opinion1="";
    private String opinion2="";
    private DocExtClass extobj1;

	public CR_130() {
	}

	public boolean initObjectForRead() {
		ARE.getLog().trace("CR_130.initObject()");
		if("".equals(opinion1))opinion1="";
//		extobj1 = new DocExtClass();
		return true;
	}

	public boolean initObjectForEdit() {
		opinion1 = " ";
		extobj1 = new DocExtClass();
		return true;
	}

	public String getOpinion1() {
		return opinion1;
	}

	public void setOpinion1(String opinion1) {
		this.opinion1 = opinion1;
	}

	public DocExtClass getExtobj1() {
		return extobj1;
	}

	public void setExtobj1(DocExtClass extobj1) {
		this.extobj1 = extobj1;
	}

	public String getOpinion2() {
		return opinion2;
	}

	public void setOpinion2(String opinion2) {
		this.opinion2 = opinion2;
	}
	
}
