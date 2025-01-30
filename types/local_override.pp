# @summary tyoe for overrideing app armor
type Apparmor::Local_override = Struct[{
    content_type => Enum['array', 'template', 'string', 'source'],
    content => Variant[String, Array],
}]
