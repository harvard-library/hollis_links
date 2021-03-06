# Development Notes

## System Object Descriptions

1. Users - Managed via devise, used to determine whether someone can alter link objects and add or delete users.

2. Links - These are just labels and URLs.  Basically never considered as individual objects.

3. LinkLists - Central data managed by this tool.  They are a collection of links and metadata about the collection.

4. Metadata - A wrapper object for MODS metadata fetched from external services (non-persisted)

## Import Format

ListView can import records from .csv or .xlsx files.  These files are broadly separated into a header section and a content section.  The header section contains metadata about the LinkList, while the content section contains labels and URLs for the individual links.  Examples are provided in [test/data](test/data).

### Header
The header consists of all rows until CONTENT_LIST marker.

Blank rows are skipped. Header rows are processed based on the values in their first cell.

* `EXT_ID_TYPE` - The type of external ID associated with a record.  This should be the name of one of the metadata sources defined by site admins ([exemplar file here](config/initializers/metadata_sources.rb.example)). MUST be present in spreadsheet before `EXT_ID`, if `EXT_ID` is included.

    |  1              | 2      |
    | --------------- | ------ |
    |  EXT\_ID\_TYPE  | hollis |

* `EXT_ID` - The ID value in said external catalog.  If you are providing an `EXT_ID`, it MUST be preceded by an `EXT_ID_TYPE`

    |  1      | 2         |
    | ------- | --------- |
    |  EXT_ID | 008675309 |

* `FTS_Search` - URL pointing at full text search for a record:

    |  1           | 2                                                    |
    | ------------ | ------------------------------------------------------ |
    |  FTS_Search  | http://fts.lib.harvard.edu/fts/search?S=HLR |

* `Continues:` - Label and URL for a preceding record; by convention, URL points to the preceding record's entry in the bibliographic catalog of record, not to the preceding ListView object if it exists.  Follows the structure:

    | 1                  | 2     | 3   |
    | -------------------- | ------- | ----- |
    | Continues: | label | URL |

* `Continued by:` - Label and URL for a succeeding record; by convention, URL points to the succeeding record's entry in the bibliographic catalog of record, not to the preceding ListView object if it exists.  Follows the structure:

    | 1                  | 2     | 3   |
    | -------------------- | ------- | ----- |
    | Continues: | label | URL |


* `FTS_NoDate` the `FTS_Search` for this record does not allow date qualification

    |  1           |  2  |
    | ------------ | --- |
    |  FTS_NoDate  |  \<blank\>   |


* Any other header rows are treated as display metadata, and should take the form:

    |  1       |  2        |
    | -------- | --------- |
    |  label:  |  content  |

### CONTENT_LIST marker
`CONTENT_LIST` in the first column with an empty second column.

|  1              |  2  |
| --------------- | --- |
|  CONTENT_LIST   | \<blank\>    |

### Links
Links consist of labels and URLs.  Should take the form:

|  1      |  2    |
| ------- | ----- |
|  label  |  URL  |

Example:

|  1                                                  |  2                                               |
| --------------------------------------------------- | ------------------------------------------------ |
|  Harvard Law Record, vol. 3, no. 3 (March 5, 1947)  |  http://nrs.harvard.edu/urn-3:HLS.LIBR:10646916  |
