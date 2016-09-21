package com.amarsoft.app.oci.comm.impl.client;


import com.amarsoft.app.oci.bean.OCITransaction;
import com.amarsoft.app.oci.exception.OCIException;
import com.amarsoft.app.oci.ws.crqs.CRQSHelper;
import com.amarsoft.app.oci.ws.decision.DecisionWebService;
import com.amarsoft.app.oci.ws.decision.DecisionWebServiceStub;
import com.amarsoft.app.oci.ws.decision.Process;
import com.amarsoft.app.oci.ws.decision.ProcessE;
import com.amarsoft.app.oci.ws.decision.ProcessResponse;
import com.amarsoft.app.oci.ws.decision.ProcessResponseE;
import com.amarsoft.are.ARE;

public class DecisionRequester implements IRequester{

	@Override
	public Object execute(OCITransaction transaction) throws OCIException {
		Object requestData = transaction.getRequestData();
		StringBuilder sb = new StringBuilder("");
		String version = transaction.getProperty("XMLVERSION");
		if(version == null || "".equals(version)) version = "1.0";
		String encoding = transaction.getProperty("XMLENOCDING");
		if(version == null || "".equals(version)) version = ARE.getProperty("CharSet","GBK");
		String endPoint = transaction.getProperty("EndPoint");
		sb.append(requestData.toString());
		transaction.setRequestData(sb.toString());
		try {
			DecisionWebService sdw = new DecisionWebServiceStub(endPoint);
			ProcessE pe = new ProcessE();
			Process pm = new Process();
			pm.setArg0(sb.toString());
			pe.setProcess(pm);
			ProcessResponseE pr =  sdw.process(pe);
			ProcessResponse prs = pr.getProcessResponse();
			transaction.setResponseData(prs.get_return());
			return prs.get_return();
		} catch (Exception e) {
			throw new OCIException(e.getMessage());
		}
	}

}
