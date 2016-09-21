package com.amarsoft.app.als.formatdoc.educationdoc;

import java.io.Serializable;

import com.amarsoft.are.ARE;
import com.amarsoft.biz.formatdoc.model.FormatDocData;

public class ED_040 extends FormatDocData implements Serializable {
	private static final long serialVersionUID = 1L;
    
    private String opinion1="";
    private String opinion2="";
    private String opinion3="";

	public ED_040() {
	}

	public boolean initObjectForRead() {
		ARE.getLog().trace("ED_040.initObject()");
		if("".equals(opinion1))opinion1="";
		if("".equals(opinion2))opinion2="";
		if("".equals(opinion3))opinion3="";
		
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

	public String getOpinion2() {
		return opinion2;
	}

	public void setOpinion2(String opinion2) {
		this.opinion2 = opinion2;
	}

	public String getOpinion3() {
		return opinion3;
	}

	public void setOpinion3(String opinion3) {
		this.opinion3 = opinion3;
	}
	
}
