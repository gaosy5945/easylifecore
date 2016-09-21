package com.amarsoft.app.als.formatdoc.currentresearchdoc;

import java.io.Serializable;
import com.amarsoft.biz.formatdoc.model.FormatDocData;
import com.amarsoft.are.ARE;

public class CR_110 extends FormatDocData implements Serializable {
	private static final long serialVersionUID = 1L;

    private String opinion1="";
    private String opinion2="";
    private String opinion3="";
    private String opinion4="";
    private String opinion5="";
    private String opinion6="";
    private String opinion7="";
    private String opinion8="";
    private String opinion9="";
    private String opinion0="";

	public CR_110() {
	}

	public boolean initObjectForRead() {
		ARE.getLog().trace("CR_110.initObject()");
		if("".equals(opinion0))opinion0="";
		if("".equals(opinion1))opinion1="";
		if("".equals(opinion2))opinion2="";
		if("".equals(opinion3))opinion3="";
		if("".equals(opinion4))opinion4="";
		if("".equals(opinion5))opinion5="";
		if("".equals(opinion6))opinion6="";
		if("".equals(opinion7))opinion7="";
		if("".equals(opinion8))opinion8="";
		if("".equals(opinion9))opinion9="";
		return true;
	}

	public boolean initObjectForEdit() {
		opinion1 = " ";
		opinion2 = " ";
		opinion3 = " ";
		opinion4 = " ";
		opinion5 = " ";
		opinion6 = " ";
		opinion7 = " ";
		opinion8 = " ";
		opinion9 = " ";
		opinion0 = " ";
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

	public String getOpinion4() {
		return opinion4;
	}

	public void setOpinion4(String opinion4) {
		this.opinion4 = opinion4;
	}

	public String getOpinion5() {
		return opinion5;
	}

	public void setOpinion5(String opinion5) {
		this.opinion5 = opinion5;
	}

	public String getOpinion6() {
		return opinion6;
	}

	public void setOpinion6(String opinion6) {
		this.opinion6 = opinion6;
	}

	public String getOpinion7() {
		return opinion7;
	}

	public void setOpinion7(String opinion7) {
		this.opinion7 = opinion7;
	}

	public String getOpinion8() {
		return opinion8;
	}

	public void setOpinion8(String opinion8) {
		this.opinion8 = opinion8;
	}

	public String getOpinion9() {
		return opinion9;
	}

	public void setOpinion9(String opinion9) {
		this.opinion9 = opinion9;
	}

	public String getOpinion0() {
		return opinion0;
	}

	public void setOpinion0(String opinion0) {
		this.opinion0 = opinion0;
	}
	
}
