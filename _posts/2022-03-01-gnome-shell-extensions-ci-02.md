---
layout: post
title: "GNOME Shell Extensions & CI: Part II"
category: tutorials
teaser: "ci2.jpg"
colors: "color-ci2"
license: "public domain"
tagline: "Testing your code is important."
tags: ["tutorial"]
---

In the second part of the series, I will show how I publish releases using GitHub Actions.

<!--more-->

If you haven't read the first one yet, I would suggest doing this before.
Here are links to the other parts:

1. [Bundling the Extension]({% post_url 2022-02-28-gnome-shell-extensions-ci-01 %})
2. [Automated Release Publishing]({% post_url 2022-03-01-gnome-shell-extensions-ci-02 %})
3. [Automated Tests with GitHub Actions]({% post_url 2022-03-02-gnome-shell-extensions-ci-03 %})

## Publishing a Release on every Tag

All you need to do, is saving the following YAML code as `.github/workflows/deploy.yml` in your extension's repository (the file name does not really matter as long it resides in the `.github/workflows` directory).

The action will be executed on every pushed tag.
It will run on an Ubuntu container, checkout your repository, install some dependencies, execute `make zip` (from the [previous part]({% post_url 2022-02-28-gnome-shell-extensions-ci-01 %})), and finally upload the resulting zip file to a new release on GitHub.
The "Install Dependencies" step is only necessary if your extension requires `gettext` in order to be built.
If your extension is not yet translated to other languages, you can delete this step.

The only thing which you will need to adapt is the zip file name in line 26, everything else is very generic.

{% highlight yaml linenos %}
name: Deploy

on:
  push:
    tags:
      - '**'

jobs:
  extension_bundle:
    name: Extension Bundle
    runs-on: ubuntu-latest
    steps:
    - name: Checkout Repository
      uses: actions/checkout@v2
    - name: Install Dependencies
      run: |
        sudo apt-get update -q
        sudo apt-get install gettext
    - name: Create Release
      run: |
        make zip
    - name: Upload Release
      uses: svenstaro/upload-release-action@2.2.1
      with:
        repo_token: {% raw %}${{ secrets.GITHUB_TOKEN }}{% endraw %}
        file: my-cool-extension@smy-cool-domain.com.zip
        tag: {% raw %}${{ github.ref }}{% endraw %}
{% endhighlight %}

That's basically everything.
If you now create a tag (let's say `v1`) and push it to GitHub, the action will be executed and your bundled extension will be uploaded to a new release!

```bash
git tag v1
git push origin v1
```

You can then give the release a proper title and description.
Finally, you can download the bundled extension and upload it to extensions.gnome.org.

## Up Next: Automated Tests

In the [last part of this series]({% post_url 2022-03-02-gnome-shell-extensions-ci-03 %}), I will show how I use GitHub Actions together with podman to automatically perform various tests on my GNOME Shell extensions.