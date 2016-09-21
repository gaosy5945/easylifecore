package com.amarsoft.app.als.formatdoc.currentresearchdoc;

import java.io.Serializable;
import com.amarsoft.biz.formatdoc.model.FormatDocData;
import com.amarsoft.are.ARE;

public class CR_032 extends FormatDocData implements Serializable {
	private static final long serialVersionUID = 1L;

    private String opinion1="";

	public CR_032() {
	}

	public boolean initObjectForRead() {
		ARE.getLog().trace("CR_032.initObject()");
		if("".equals(opinion1))opinion1="";
		return true;
	}

	public boolean initObjectForEdit() {
		opinion1 = " ";
		return true;
	}

	public String getOpinion1() {
		return opinion1;
	}

	public void setOpinion1(String opinion1) {
		this.opinion1 = opinion1;
	}	
}
