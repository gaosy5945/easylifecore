package com.amarsoft.app.als.formatdoc.medicaldoc;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;
import java.util.Properties;
import com.amarsoft.app.als.formatdoc.DocExtClass;
import com.amarsoft.are.ARE;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.util.DataConvert;
import com.amarsoft.biz.formatdoc.model.FormatDocData;
import com.amarsoft.dict.als.manage.CodeManager;
import com.amarsoft.dict.als.manage.NameManager;

public class MED_060 extends FormatDocData implements Serializable {
	private static final long serialVersionUID = 1L;
    
    private String opinion1="";

	public MED_060() {
	}

	public boolean initObjectForRead() {
		ARE.getLog().trace("MED_060.initObject()");
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
