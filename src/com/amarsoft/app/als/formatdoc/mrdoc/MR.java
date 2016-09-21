package com.amarsoft.app.als.formatdoc.mrdoc;

import java.io.Serializable;

import com.amarsoft.app.als.formatdoc.DocExtClass;
import com.amarsoft.biz.formatdoc.model.FormatDocData;
import com.amarsoft.are.ARE;

public class MR extends FormatDocData implements Serializable {
	private static final long serialVersionUID = 1L;
	
	private DocExtClass extobj1;
	private DocExtClass extobj2;
	private DocExtClass extobj3;
	private DocExtClass extobj4;
    private String opinion1 = "";
    private String opinion2 = "";
    private String opinion3 = "";

	public MR() {
	}

	public boolean initObjectForRead() {
		ARE.getLog().trace("MR.initObject()");
		
		String sObjectNo=this.getRecordObjectNo();
		String sObjectType=this.getRecordObjectType();
		if(sObjectNo==null)sObjectNo="";
		if(sObjectType==null)sObjectType="";
		
		return true;
	}

	public boolean initObjectForEdit() {
		extobj1 = new DocExtClass();
		extobj2 = new DocExtClass();
		extobj3 = new DocExtClass();
		extobj4 = new DocExtClass();
		opinion1 = " ";
		opinion2 = " ";
		opinion3 = " ";
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

	public DocExtClass getExtobj1() {
		return extobj1;
	}

	public void setExtobj1(DocExtClass extobj1) {
		this.extobj1 = extobj1;
	}

	public DocExtClass getExtobj2() {
		return extobj2;
	}

	public void setExtobj2(DocExtClass extobj2) {
		this.extobj2 = extobj2;
	}

	public DocExtClass getExtobj3() {
		return extobj3;
	}

	public void setExtobj3(DocExtClass extobj3) {
		this.extobj3 = extobj3;
	}

	public DocExtClass getExtobj4() {
		return extobj4;
	}

	public void setExtobj4(DocExtClass extobj4) {
		this.extobj4 = extobj4;
	}
	
}
