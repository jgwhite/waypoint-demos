project = "pipelines"

pipeline "one-step" {
  step "hi" {
    image_url = "busybox"
    use "exec" {
      command = "echo"
      args = ["hi"]
    }
  }
}

pipeline "two-step" {
  step "hi" {
    image_url = "busybox"
    use "exec" {
      command = "echo"
      args = ["hi"]
    }
  }
  step "bye" {
    image_url = "busybox"
    use "exec" {
      command = "echo"
      args = ["bye"]
    }
  }
}

pipeline "three-step-referenced" {
  step "prep" {
    image_url = "busybox"
    use "exec" {
      command = "echo"
      args = ["preparing"]
    }
  }
  step "reference-two-step" {
    use "pipeline" {
      project = "pipelines"
      name = "two-step"
    }
  }
}

pipeline "three-step-nested" {
  step "prep" {
    image_url = "busybox"
    use "exec" {
      command = "echo"
      args = ["preparing"]
    }
  }
  step "nested-step" {
    pipeline "nested-pipeline" {
      step "hi" {
        image_url = "busybox"
        use "exec" {
          command = "echo"
          args = ["hi"]
        }
      }
      step "bye" {
        image_url = "busybox"
        use "exec" {
          command = "echo"
          args = ["bye"]
        }
      }
    }
  }
}

runner {
  enabled = true

  data_source "git" {
    url  = "https://github.com/jgwhite/waypoint-demos.git"
    ref  = "main"
    path = "pipelines"
  }
}

app "web" {
  build {
    use "docker" {}
  }

  deploy {
    use "docker" {}
  }
}
