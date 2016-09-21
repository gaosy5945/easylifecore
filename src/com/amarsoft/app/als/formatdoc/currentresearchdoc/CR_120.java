package com.amarsoft.app.als.formatdoc.currentresearchdoc;

import java.io.Serializable;
import com.amarsoft.biz.formatdoc.model.FormatDocData;
import com.amarsoft.are.ARE;

public class CR_120 extends FormatDocData implements Serializable {
	private static final long serialVersionUID = 1L;

    private String opinion1="";
    private String opinion2="";

	public CR_120() {
	}

	public boolean initObjectForRead() {
		ARE.getLog().trace("CR_120.initObject()");
		if("".equals(opinion1))opinion1="";
		if("".equals(opinion2))opinion2="";
		return true;
	}

	public boolean initObjectForEdit() {
		opinion1 = " ";
		opinion2 = " ";
		return true;
	}

	public String getOpinion1() {
		return opinion1;
	}

	public void setOpinion1(String opinion1) {
		this.opinion1 = opinion1;
	}

	public String getOpinion2() {
		return opinion2;
	}

	public void setOpinion2(String opinion2) {
		this.opinion2 = opinion2;
	}
	
}
