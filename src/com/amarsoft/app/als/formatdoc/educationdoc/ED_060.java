package com.amarsoft.app.als.formatdoc.educationdoc;

import java.io.Serializable;

import com.amarsoft.are.ARE;
import com.amarsoft.biz.formatdoc.model.FormatDocData;

public class ED_060 extends FormatDocData implements Serializable {
	private static final long serialVersionUID = 1L;
    
    private String opinion1="";

	public ED_060() {
	}

	public boolean initObjectForRead() {
		ARE.getLog().trace("ED_060.initObject()");
		if("".equals(opinion1))opinion1="";
		
		return true;
	}

	public boolean initObjectForEdit() {
		return true;
	}

	public String getOpinion1() {
		return opinion1;
	}

	public void setOpinion1(String opinion1) {
		this.opinion1 = opinion1;
	}
	
}
