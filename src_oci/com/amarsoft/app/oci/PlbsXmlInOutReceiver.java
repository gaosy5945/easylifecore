package com.amarsoft.app.oci;

/**
 *  接口接受返回参数处理类
 */
import java.lang.reflect.Method;

import javax.xml.namespace.QName;

import org.apache.axiom.om.OMElement;
import org.apache.axiom.soap.SOAPBody;
import org.apache.axiom.soap.SOAPEnvelope;
import org.apache.axiom.soap.SOAPFactory;
import org.apache.axis2.AxisFault;
import org.apache.axis2.context.MessageContext;
import org.apache.axis2.description.AxisOperation;
import org.apache.axis2.engine.MessageReceiver;
import org.apache.axis2.i18n.Messages;
import org.apache.axis2.receivers.AbstractInOutSyncMessageReceiver;

public class PlbsXmlInOutReceiver extends AbstractInOutSyncMessageReceiver
  implements MessageReceiver
{
  private Method findOperation(AxisOperation op, Class implClass)
  {
    Method method = (Method)(Method)op.getParameterValue("myMethod");
    if ((method != null) && (method.getDeclaringClass() == implClass)) return method;

    String methodName = op.getName().getLocalPart();
    try
    {
      method = implClass.getMethod(methodName, new Class[] { SOAPEnvelope.class });
      if (method.getReturnType().equals(SOAPEnvelope.class)) {
        try {
          op.addParameter("myMethod", method);
        }
        catch (AxisFault axisFault) {
        }
        return method;
      }
    }
    catch (NoSuchMethodException e)
    {
    }
    return null;
  }

  public void invokeBusinessLogic(MessageContext msgContext, MessageContext newmsgContext)
    throws AxisFault
  {
    try
    {
      Object obj = getTheImplementationObject(msgContext);

      Class implClass = obj.getClass();

      AxisOperation opDesc = msgContext.getAxisOperation();
      Method method = findOperation(opDesc, implClass);

      if (method == null) {
        throw new AxisFault(Messages.getMessage("methodDoesNotExistInOut", opDesc.getName().toString()));
      }

      SOAPEnvelope result = (SOAPEnvelope)method.invoke(obj, new Object[] { msgContext.getEnvelope()});

      SOAPFactory fac = getSOAPFactory(msgContext);

      newmsgContext.setEnvelope(result);
    } catch (Exception e) {
      throw AxisFault.makeFault(e);
    }
  }
}