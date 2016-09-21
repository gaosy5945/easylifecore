package com.amarsoft.app.oci.comm.impl.server;

import java.io.ByteArrayInputStream;
import java.util.HashMap;
import java.util.Map;

import javax.xml.stream.FactoryConfigurationError;
import javax.xml.stream.XMLInputFactory;
import javax.xml.stream.XMLStreamException;
import javax.xml.stream.XMLStreamReader;

import org.apache.axiom.om.OMAbstractFactory;
import org.apache.axiom.om.OMElement;
import org.apache.axiom.om.impl.builder.StAXOMBuilder;

import com.amarsoft.app.oci.bean.Field;
import com.amarsoft.app.oci.bean.Message;
import com.amarsoft.app.oci.bean.OCITransaction;
import com.amarsoft.app.oci.exception.OCIException;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;

/**
 * 业务处理类
 * 
 * @author xjzhao
 * 
 */
public class WSResponser implements IResponser {

	public void dispose(OCITransaction trans) throws Exception {
		Message message = trans.getIMessage("SysBody");
		Field field = message.getFieldByTag("SvcBody");

		String value = "";
		XMLStreamReader reader;
		try {
			reader = XMLInputFactory.newInstance().createXMLStreamReader(
					new ByteArrayInputStream(value.getBytes()));
			StAXOMBuilder builder = new StAXOMBuilder(reader);
			OMElement element = builder.getDocumentElement();

		} catch (Exception e) {
			e.printStackTrace();
		}
		
		//field.getObjectMessage().getFieldByTag("Content").getFieldValue();
		
		try {
			BizObjectManager bm = JBOFactory.getBizObjectManager("jbo.sys.");
			BizObject bo = bm.newObject();
			bo.setAttributeValue("SYSID", "");
			bo.setAttributeValue("MACID", "");
			bo.setAttributeValue("", "");
			bo.setAttributeValue("", "");
			bm.saveObject(bo);
		} catch (JBOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
	}

	public Map<String, String> getErrorMap(OCIException e, OCITransaction trans) {
		Map<String, String> errorMap = new HashMap<String, String>();

		return errorMap;
	}

}
