package com.amarsoft.app.als.document.attechment;

import java.util.List;

import com.amarsoft.app.als.awe.ow.ALSBusinessProcess;
import com.amarsoft.app.als.awe.ow.processor.BusinessObjectOWDeleter;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;

public class DocumentLibraryBusinessProcess extends ALSBusinessProcess implements
		BusinessObjectOWDeleter {
	@Override
	public int delete(BusinessObject businessObject,
			ALSBusinessProcess businessProcess) throws Exception {
		BusinessObjectManager bomanager = businessProcess.getBusinessObjectManager();
		bomanager.deleteBusinessObject(businessObject);
		String docNo = businessObject.getString("DocNo");
		bomanager.deleteBusinessObjects(bomanager.loadBusinessObjects("jbo.doc.DOC_ATTACHMENT", "DocNo=:DocNo", "DocNo",docNo));
		bomanager.deleteBusinessObjects(bomanager.loadBusinessObjects("jbo.doc.DOC_RELATIVE", "DocNo=:DocNo", "DocNo",docNo));
		bomanager.updateDB();
		
		return 1;
	}

	@Override
	public int delete(List<BusinessObject> businessObjectList,
			ALSBusinessProcess businessProcess) throws Exception {
		for(BusinessObject businessObject:businessObjectList){
			delete(businessObject,businessProcess);
		}
		return 1;
	}
}
