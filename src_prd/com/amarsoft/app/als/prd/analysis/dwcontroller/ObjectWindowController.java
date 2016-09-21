package com.amarsoft.app.als.prd.analysis.dwcontroller;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.awe.dw.ASDataWindow;


/**
 * datawindow¿ØÖÆÆ÷
 * @author amarsoft
 *
 */
public interface ObjectWindowController {
	public void initDataWindow(ASDataWindow dwTemp,BusinessObject inputParameters) throws Exception;
}
