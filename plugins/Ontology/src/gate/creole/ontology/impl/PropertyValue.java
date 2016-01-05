/**
 * PropertyValue.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.3 Oct 05, 2005 (05:23:37 EDT) WSDL2Java emitter.
 */

package gate.creole.ontology.impl;

public class PropertyValue {
    private String datatype;

    private String value;

    public PropertyValue() {
    }

    public PropertyValue(
           String datatype,
           String value) {
           this.datatype = datatype;
           this.value = value;
    }


    /**
     * Gets the datatype value for this PropertyValue.
     * 
     * @return datatype
     */
    public String getDatatype() {
        return datatype;
    }


    /**
     * Sets the datatype value for this PropertyValue.
     * 
     * @param datatype
     */
    public void setDatatype(String datatype) {
        this.datatype = datatype;
    }


    /**
     * Gets the value value for this PropertyValue.
     * 
     * @return value
     */
    public String getValue() {
        return value;
    }


    /**
     * Sets the value value for this PropertyValue.
     * 
     * @param value
     */
    public void setValue(String value) {
        this.value = value;
    }
}
