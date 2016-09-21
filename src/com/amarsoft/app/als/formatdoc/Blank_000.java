package com.amarsoft.app.als.formatdoc;

import com.amarsoft.biz.formatdoc.model.FormatDocData;
import com.amarsoft.are.ARE;
import java.io.Serializable;

public class Blank_000 extends FormatDocData implements Serializable {
	private static final long serialVersionUID = 1L;

	public Blank_000() {
	}

	public boolean initObjectForEdit() {
		ARE.getLog().trace("Blank_000.initObject()");
		return true;
	}
	
	public boolean initObjectForRead() {
		return true;
	}
}
